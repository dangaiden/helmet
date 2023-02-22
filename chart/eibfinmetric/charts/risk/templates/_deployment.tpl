{{- define "risk.deployment" -}}
{{ $name := index . 0}}
{{ $dot := index . 1}}
{{ $curr:= get $dot.Values $name }}
{{- if $curr.enabled -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "service.fullname" . }}
  namespace: {{ include "namespace" $dot }}
  labels:
    {{- include "service.labels" . | nindent 4 }}
spec:
  replicas: {{ $curr.replicaCount }}
  selector:
    matchLabels:
      {{- include "service.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with $curr.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "service.selectorLabels" . | nindent 8 }}
    spec:
      {{- include "images.pullSecrets" (dict "images" (list $curr.image) "default" $dot.Values.default.image) | nindent 6 }}
      {{- if $dot.Values.podSecurityContext.enabled }}
      securityContext: {{- omit $dot.Values.podSecurityContext "enabled" | toYaml | nindent 8 }}
      {{- end }}
      initContainers:
      {{- if $curr.check.db }}
      - name: check-db-ready
        {{- (include "db.wait" $dot) | nindent 8  }}
      {{- end }}
      containers:
        - name: {{ $dot.Chart.Name }}
          {{- if $dot.Values.containerSecurityContext.enabled }}
          securityContext: {{- omit .Values.containerSecurityContext "enabled" | toYaml | nindent 12 }}
          {{- end }}
          image: {{ include "images.image" (dict "imageRoot" $curr.image "default" $dot.Values.default.image) }}
          imagePullPolicy: {{ $curr.image.pullPolicy | default $dot.Values.default.image.pullPolicy | quote }}
          env:
          - name: ASPNETCORE_ENVIRONMENT
            value: {{- $curr.ASPNETCORE_ENVIRONMENT | default $dot.Values.default.ASPNETCORE_ENVIRONMENT | nindent 14 }}
          - name: APP_TARGET
            value: {{- $curr.APP_TARGET | default $dot.Values.default.APP_TARGET | nindent 14 }}
          {{- if $curr.application }}
          - name: ENVIRONMENT__APPLICATION
            value: {{- $curr.application | nindent 14 }}
          {{- end }}
          - name: Kestrel__EndPoints__0__Url
            value: {{ printf "http://*:%g" $curr.service.containerPort }}
          - name: ASPNETCORE_URLS
            value: {{ printf "http://*:%g" $curr.service.containerPort }}
          {{- if $curr.env }}
          {{- toYaml $curr.env | nindent 10 }}
          {{- end }}
          envFrom:
          - configMapRef:
              name: {{ include "db-config.fullname" $dot }}
          - configMapRef:
              name: {{ include "cache-config.fullname" $dot }}
          - configMapRef:
              name: {{ include "mq-config.fullname" $dot }}
          - configMapRef:
              name: {{ include "endpoints-config.fullname" $dot }}
          ports:
            - name: http-target
              containerPort: {{ $curr.service.containerPort }}
              protocol: TCP
          resources:
            {{- toYaml $curr.resources | nindent 12 }}
      {{- with $curr.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $curr.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $curr.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end -}}
{{- end -}}