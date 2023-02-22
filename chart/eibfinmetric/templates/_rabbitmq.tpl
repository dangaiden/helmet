# rabbitmq
{{- define "rabbitmq.fullname" -}}
{{- printf "%s-%s" .Release.Name "rabbitmq" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rabbitmq.connection" -}}
{{- $port := int (include "rabbitmq.port" .) }}
{{- $user := (include "rabbitmq.user" .) }}
{{- $password := (include "rabbitmq.password" .) }}
{{- $host := (include "rabbitmq.host" .) }}
{{- printf "amqp://%s:%s@%s:%d" $user $password $host $port }}
{{- end -}}


{{- define "rabbitmq.host" -}}
{{- printf "%s-%s.%s" .Release.Name "rabbitmq" .Release.Namespace }}
{{- end -}}

{{- define "rabbitmq.user" -}}
{{- .Values.rabbitmq.auth.username }}
{{- end -}}

{{- define "rabbitmq.password" -}}
{{- .Values.rabbitmq.auth.password }}
{{- end -}}


{{- define "rabbitmq.port" -}}
{{- .Values.rabbitmq.service.ports.amqp }}
{{- end -}}