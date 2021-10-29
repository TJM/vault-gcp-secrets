{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "vault-gcr-secrets.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vault-gcr-secrets.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vault-gcr-secrets.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "vault-gcr-secrets.labels" -}}
app.kubernetes.io/name: {{ include "vault-gcr-secrets.name" . }}
helm.sh/chart: {{ include "vault-gcr-secrets.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels }}
{{- end }}
{{- end -}}

{{/*
matchLabels
*/}}
{{- define "vault-gcr-secrets.matchLabels" -}}
app.kubernetes.io/name: {{ include "vault-gcr-secrets.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Additional pod annotations
*/}}
{{- define "vault-gcr-secrets.annotations" -}}
{{- if .Values.podAnnotations }}
{{- toYaml .Values.podAnnotations }}
{{- end }}
{{- end -}}

{{/*
Additional test-connection pod annotations
*/}}
{{- define "vault-gcr-secrets.testPodAnnotations" -}}
{{- if .Values.testPodAnnotations }}
{{- toYaml .Values.testPodAnnotations }}
{{- end }}
{{- end }}

{{/*
Additional test-connection pod labels
*/}}
{{- define "vault-gcr-secrets.testPodLabels" -}}
{{- if .Values.testPodLabels }}
{{- toYaml .Values.testPodLabels }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "vault-gcr-secrets.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "vault-gcr-secrets.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Additional containers to add to the deployment
*/}}
{{- define "vault-gcr-secrets.additionalContainers" -}}
{{- end -}}
