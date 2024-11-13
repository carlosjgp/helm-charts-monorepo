{{/*
Expand the name of the chart.
*/}}
{{- define "launch-darkly.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "launch-darkly.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "launch-darkly.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Version of the application
*/}}
{{- define "launch-darkly.version" -}}
{{- .Values.image.tag | default .Chart.AppVersion | required "'image.tag' is required" -}}
{{- end }}

{{/*
Deployment image
*/}}
{{- define "launch-darkly.deploymentImage" -}}
{{- $repo := .Values.image.repository | required "'image.repository' is required" -}}
{{- printf "%s:%s" $repo (include "launch-darkly.version" .) -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "launch-darkly.labels" -}}
helm.sh/chart: {{ include "launch-darkly.chart" . }}
{{ include "launch-darkly.selectorLabels" . }}
app.kubernetes.io/version: {{ include "launch-darkly.version" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "launch-darkly.selectorLabels" -}}
app.kubernetes.io/name: {{ include "launch-darkly.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Deployment annotations
*/}}
{{- define "launch-darkly.deployment.annotations" -}}
reloader.stakater.com/auto: "true"
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "launch-darkly.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "launch-darkly.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
status exporter image
*/}}
{{- define "launch-darkly.exporter.image" -}}
{{- $repo := include "common.tplvalues.render" (dict "value" .Values.statusExporter.image.repository "context" .) -}}
{{- printf "%s:%s" $repo .Values.statusExporter.image.tag -}}
{{- end -}}


{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
