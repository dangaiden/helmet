# Cluster namespace
{{- define "namespace" -}}
{{- default .Release.Namespace -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "risk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "risk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "risk.labels" -}}
helm.sh/chart: {{ include "risk.chart" . }}
{{ include "risk.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "risk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "risk.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}



{{/*
NOTE: This utility template is needed until https://github.com/helm/helm/issues/3920 is resolved.
Call a template from the context of a subchart.
Usage:
  {{ include "call-nested" (list . "<subchart_name>" "<subchart_template_name>") }}
*/}}
{{- define "call-nested" -}}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 }}
{{- $template := index . 2 }}
{{- include $template (dict "Chart" (dict "Name" $subchart) "Values" (index $dot.Values $subchart) "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end -}}


{{- define "db-config.fullname" -}}
{{- printf "%s-%s" .Release.Name "db-config" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "db-wait-config.fullname" -}}
{{- printf "%s-%s" .Release.Name "db-wait-config" | trunc 63 | trimSuffix "-" }}
{{- end -}}


{{- define "endpoints-config.fullname" -}}
{{- printf "%s-%s" .Release.Name "endpoints-config" | trunc 63 | trimSuffix "-" }}
{{- end -}}


{{- define "cache-config.fullname" -}}
{{- printf "%s-%s" .Release.Name "cache-config" | trunc 63 | trimSuffix "-" }}
{{- end -}}


{{- define "mq-config.fullname" -}}
{{- printf "%s-%s" .Release.Name "mq-config" | trunc 63 | trimSuffix "-" }}
{{- end -}}


{{- define "services-config.fullname" -}}
{{- printf "%s-%s" .Release.Name "services-config" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Service name 
*/}}
{{- define "service.name" }}
{{- $name := index . 0 }}
{{- $dot := index . 1 }}
{{- $values := $dot.Values }}
{{- $srv := get $values $name }}
{{- printf "%s" $srv.name }}
{{- end -}}
{{/*
Full service name 
*/}}
{{- define "service.fullname" }}
{{- $name := index . 0 -}}
{{- $dot := index . 1 -}}
{{ $name := include "service.name" . -}}
{{- printf "%s-%s" $dot.Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{/*
Selector labels
*/}}
{{- define "service.selectorLabels" }}
{{- $name := index . 0 }}
{{- $dot := index . 1 }}
app.kubernetes.io/name: {{ include "service.name" . }}
app.kubernetes.io/instance: {{ $dot.Release.Name }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "service.labels" -}}
{{- $name := index . 0 }}
{{- $dot := index . 1 }}
helm.sh/chart: {{ include "risk.chart" $dot }}
{{ include "service.selectorLabels" . }}
{{- if $dot.Chart.AppVersion }}
app.kubernetes.io/version: {{ $dot.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $dot.Release.Service }}
{{- end -}}