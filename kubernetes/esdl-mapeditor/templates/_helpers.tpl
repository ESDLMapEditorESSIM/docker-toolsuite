{{- /*
  Helper: mapeditor.host
  - returns "subdomain.domainExtension" or just "domainExtension" if subdomain is empty
*/ -}}
{{- define "mapeditor.host" -}}
{{- $ext := .Values.global.domainExtension -}}
{{- $sub := .Values.mapeditor.subdomain | default "" -}}
{{- if ne $sub "" -}}
{{- printf "%s.%s" $sub $ext -}}
{{- else -}}
{{- $ext -}}
{{- end -}}
{{- end -}}
