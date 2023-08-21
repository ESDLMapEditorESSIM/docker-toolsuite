# =====================================================================================================================
#   Script to upload profile data from a CSV file
# =====================================================================================================================
import locale
locale.setlocale(locale.LC_ALL, '')

import csv
import glob
import os
import codecs
from influxdb import InfluxDBClient


db_host = "localhost"
db_port = 8086
db_name = 'energy_profiles'
db_user = "admin"
db_passwd = "admin"


def connect_database():
    client = InfluxDBClient(host=db_host, port=db_port, username=db_user, password=db_passwd, database=db_name)
    if db_name not in client.get_list_database():
        client.create_database(db_name)
    return client


def format_datetime(dt):
    date, time = dt.split(" ")
    day, month, year = date.split("-")
    ndate = year + "-" + month + "-" + day
    ntime = time + ":00+0000"
    return ndate + "T" + ntime


def process_profiles_csv(client, file_path):
    path_parts = os.path.split(file_path)
    file_name = path_parts[-1]
    measurement = os.path.splitext(file_name)[0]

    with codecs.open(file_path, encoding='utf-8-sig') as csv_file:
        reader = csv.reader(csv_file, delimiter=';')

        column_names = next(reader)
        print(column_names)

        num_fields = len(column_names)
        json_body = []

        for row in reader:
            fields = {}
            for i in range(1, num_fields):
                if row[i]:
                    fields[column_names[i]] = locale.atof(row[i])

            json_body.append({
                "measurement": measurement,
                "time": format_datetime(row[0]),
                "fields": fields
            })

        client.write_points(points=json_body, database=db_name, batch_size=100)


if __name__ == "__main__":
    client = connect_database()

    for filename in glob.glob("./*.csv"):
        process_profiles_csv(client, filename)
