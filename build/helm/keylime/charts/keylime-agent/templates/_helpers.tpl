{{/*
Expand the name of the chart.
*/}}
{{- define "agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
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
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agent.labels" -}}
helm.sh/chart: {{ include "agent.chart" . }}
{{ include "agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Expand to the name of the config map to be used
*/}}
{{- define "agent.configMap" -}}
{{- if .Values.global.configmap.create }}
{{- include "keylime.configMap" . }}
{{- else }}
{{- default (include "keylime.configMap" .) .Values.global.configmap.agentName }}
{{- end }}
{{- end }}

{{/*
Expand to the secret name for the certificate volume to be used
*/}}
{{- define "agent.cvca.secret" -}}
{{- if .Values.global.ca.generate }}
{{- include "keylime.ca.secret.certs" . }}
{{- else }}
{{- default (include "keylime.ca.secret.certs" .) .Values.global.ca.agentName }}
{{- end }}
{{- end }}

{{/*
Decide on a privileged or unprivileged securityContext for a pod
*/}}
{{- define "agent.secctx" -}}
{{- if .Values.global.service.agent.privileged }}
{{- toYaml .Values.privsecurityContext }}
{{- else }}
{{- toYaml .Values.unprivsecurityContext }}
{{- end }}
{{- end }}

{{/*
Decide on a privileged or unprivileged resources for a pod
*/}}
{{- define "agent.resources" -}}
{{- if .Values.global.service.agent.privileged }}
{{- toYaml .Values.privresources }}
{{- else }}
{{- toYaml .Values.unprivresources }}
{{- end }}
{{- end }}
