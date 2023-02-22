{{- define "risk.service" }}
{{ $name := index . 0}}
{{ $dot := index . 1}}
{{ $curr:= get $dot.Values $name }}
{{- if $curr.enabled -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "service.fullname" . }}
  namespace: {{ include "namespace" $dot }}
  labels:
    {{- include "service.labels" . | nindent 4 }}
spec:
  type: {{ $curr.service.type }}
  ports:
    - port: {{ $curr.service.port }}
      targetPort: http-target
      protocol: TCP
      name: http
  selector:
    {{- include "service.selectorLabels" . | nindent 4 }}
{{- end -}}
{{- end -}}