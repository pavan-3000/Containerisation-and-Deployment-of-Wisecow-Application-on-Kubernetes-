{{- define "wisecow.name" -}}
{{- .Release.Name }}
{{- end }}

{{- define "wisecow.fullname" -}}
{{- .Release.Name }}-{{ .Chart.Name }}
{{- end }}
