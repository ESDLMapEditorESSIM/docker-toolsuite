# =====================================================================================================================
#   Script to upload profile data from CSV files
# =====================================================================================================================
import argparse
import codecs
import csv
import glob
import locale
import os

from influxdb import InfluxDBClient

locale.setlocale(locale.LC_ALL, "")

DEFAULT_DB_HOST = "localhost"
DEFAULT_DB_PORT = 8086
DEFAULT_DB_NAME = "energy_profiles"
DEFAULT_DB_USER = "admin"
DEFAULT_DB_PASSWORD = "admin"


def parse_args():
    parser = argparse.ArgumentParser(description="Upload profile CSV files to InfluxDB.")
    parser.add_argument("files", nargs="*", help="CSV files to upload. Defaults to all *.csv files in the current directory.")
    parser.add_argument("--host", default=DEFAULT_DB_HOST, help="InfluxDB host.")
    parser.add_argument("--port", default=DEFAULT_DB_PORT, type=int, help="InfluxDB port.")
    parser.add_argument("--database", default=DEFAULT_DB_NAME, help="InfluxDB database.")
    parser.add_argument("--user", default=DEFAULT_DB_USER, help="InfluxDB user.")
    parser.add_argument("--password", default=DEFAULT_DB_PASSWORD, help="InfluxDB password.")
    parser.add_argument("--ssl", action="store_true", help="Use HTTPS to connect to InfluxDB.")
    parser.add_argument("--no-verify-ssl", action="store_true", help="Disable HTTPS certificate verification.")
    parser.add_argument("--drop-measurement", action="store_true", help="Drop each measurement before uploading it.")
    return parser.parse_args()


def connect_database(args):
    client = InfluxDBClient(
        host=args.host,
        port=args.port,
        username=args.user,
        password=args.password,
        database=args.database,
        ssl=args.ssl,
        verify_ssl=not args.no_verify_ssl,
    )
    databases = [database["name"] for database in client.get_list_database()]
    if args.database not in databases:
        client.create_database(args.database)
    return client


def format_datetime(dt):
    date, time = dt.split(" ")
    day, month, year = date.split("-")
    ndate = year + "-" + month + "-" + day
    ntime = time + ":00+0000"
    return ndate + "T" + ntime


def process_profiles_csv(client, file_path, database, drop_measurement=False):
    path_parts = os.path.split(file_path)
    file_name = path_parts[-1]
    measurement = os.path.splitext(file_name)[0]

    if drop_measurement:
        client.drop_measurement(measurement)

    with codecs.open(file_path, encoding="utf-8-sig") as csv_file:
        reader = csv.reader(csv_file, delimiter=";")

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
                "fields": fields,
            })

        client.write_points(points=json_body, database=database, batch_size=100)


def get_files(files):
    if files:
        return files
    return glob.glob("./*.csv")


if __name__ == "__main__":
    parsed_args = parse_args()
    influx_client = connect_database(parsed_args)

    for filename in get_files(parsed_args.files):
        process_profiles_csv(
            influx_client,
            filename,
            parsed_args.database,
            drop_measurement=parsed_args.drop_measurement,
        )
