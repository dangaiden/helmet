{{/*
Return the proper image name
{{ include "images.image" ( dict "imageRoot" .Values.path.to.the.image "default" $) }}
*/}}
{{- define "images.image" -}}
{{- $registryName := .default.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .default.tag | toString -}}
{{- if .imageRoot.registry }}
  {{- $registryName = .imageRoot.registry -}}
{{- end -}}
{{- if .imageRoot.tag }}
  {{- $tag = .imageRoot.tag | toString -}}
{{- end -}}
{{- if $registryName }}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
{{ include "images.pullSecrets" ( dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "global" .Values.default) }}
*/}}
{{- define "images.pullSecrets" -}}
  {{- $pullSecrets := list }}

  {{- if .default }}
    {{- range .default.pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- range .images -}}
    {{- range .pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}

  {{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
    {{- range $pullSecrets }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}
