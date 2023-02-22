# redis
{{- define "redis.host" }}
{{- $port := int .Values.redis.redisPort }}
{{- printf "%s-%s-master.%s:%d" .Release.Name "redis" .Release.Namespace $port }}
{{- end }}

{{- define "redis.connection" }}
{{- $port := int .Values.redis.redisPort }}
{{- printf "%s-%s-master.%s:%d,syncTimeout=60000000,abortConnect=false" .Release.Name "redis" .Release.Namespace $port }}
{{- end }}
