{{- define "risk.autoscaler" -}}
{{ $name := index . 0}}
{{ $dot := index . 1}}
{{ $curr:= get $dot.Values $name }}
{{- if $curr.autoscaling.enabled }}
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "service.fullname" . }}-autoscaler
  namespace: {{ include "namespace" $dot }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "service.fullname" . }}
  minReplicas: {{ $curr.autoscaling.minReplicas }}
  maxReplicas: {{ $curr.autoscaling.maxReplicas }}
{{- with $curr.autoscaling.metrics }}
  metrics:
    {{- toYaml . | nindent 2}}
{{- end }}
{{- end -}}
{{- end -}}