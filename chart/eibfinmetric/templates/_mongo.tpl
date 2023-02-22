
# mongo
#  https://github.com/helm/helm/issues/3920



{{- define "mongo.host" -}}
{{- $port := int .Values.mongodb.service.ports.mongodb }}
{{- printf "%s-%s.%s:%d" .Release.Name "mongodb" .Release.Namespace $port }}
{{- end -}}


{{- define "mongo.connection" -}}
{{- $port := int .Values.mongodb.service.ports.mongodb }}
{{- printf "mongodb://%s-%s.%s:%d" .Release.Name "mongodb" .Release.Namespace $port }}
{{- end -}}

{{- define "mongo.connection.params" -}}
{{- printf "maxpoolsize=1001&retryWrites=true"}} 
{{- end -}}


{{- define "mongo.connection.main" -}}
{{- printf "%s/%s?%s" (include "mongo.connection" .) (.Values.global.db.main.name) (include "mongo.connection.params" .) }} 
{{- end -}}


{{- define "mongo.connection.reports" -}}
{{- printf "%s/%s?%s" (include "mongo.connection" .) (.Values.global.db.reports.name) (include "mongo.connection.params" .) }} 
{{- end -}}

{{- define "mongo.connection.maket-quotes" -}}
{{- printf "%s/%s?%s" (include "mongo.connection" .) (.Values.global.db.market_quotes.name) (include "mongo.connection.params" .) }} 
{{- end -}}


{{- define "mongo.connection.main.restore" -}}
{{- printf "%s" (include "mongo.connection" .) }} 
{{- end -}}

{{- define "mongo.connection.staging.restore" -}}
{{- printf "%s" (include "mongo.connection" .) }} 
{{- end -}}

{{- define "mongo.connection.mq.restore" -}}
{{- printf "%s" (include "mongo.connection" .) }} 
{{- end -}}


{{- define "main.backup.image" -}}
{{- include "images.image" (dict "imageRoot" .Values.db.main.restore.image "default" .Values.risk.default.image) }}
{{- end -}}

{{- define "staging.backup.image" -}}
{{- include "images.image" (dict "imageRoot" .Values.db.staging.restore.image "default" .Values.risk.default.image) }}
{{- end -}}

{{- define "restore-main-db-job.fullname" -}}
{{- printf "%s-%s" .Release.Name "restore-main-db" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "restore-staging-db-job.fullname" -}}
{{- printf "%s-%s" .Release.Name "restore-staging-db" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "db.wait" -}}
image:  {{ .Values.global.init.db.image }}
command:
  - "sh"
  - "-c"
  - "until mongo --host $(HOST) --disableImplicitSessions --eval \"db.adminCommand('ping')\"; do echo waiting for database; sleep 2; done;"
env:
  - name: HOST
    valueFrom:
      configMapKeyRef:
        key: Host
        name: {{ include "db-config.fullname" .}} 
{{- end -}}