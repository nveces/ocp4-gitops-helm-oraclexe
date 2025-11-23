{{/*
[01] Expand the name of the chart.
*/}}
{{- define "oraclexe.chartname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
[02] Expand the name of the app components
*/}}
{{- define "oraclexe.name" -}}
{{- default .Values.app.name .Values.nameOverride | trunc 63 }}
{{- end }}

{{/*
[03] Get the "application" prefix for componets
*/}}
{{- define "oraclexe.nameWithSuffix" -}}
{{- $ctx := .context -}}
{{- $suffix := .suffix | default "" -}}
{{- $appName := include "oraclexe.name" $ctx }}

{{- if $suffix -}}
{{- printf "%s-%s" $appName .suffix |trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- default $appName | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
[04] Get the "version" application
*/}}
{{- define "oraclexe.appversion" -}}
{{- default .Values.app.version .Chart.Version | replace "+" "_" | quote | trunc 63 }}
{{- end }}

{{/*
[05] Create chart name and version as used by the chart label.
*/}}
{{- define "oraclexe.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 }}
{{- end }}


{{/*
[06] Plural Selector labels to use with "matchLabels"
*/}}
{{- define "oraclexe.selectorLabels" -}}
application: {{ include "oraclexe.name" . }}
app: {{ include "oraclexe.name" . }}
app.kubernetes.io/name: {{ include "oraclexe.name" . }}
{{- end }}

{{/*
[07] Singular Selector labels to use with "matchLabels"
*/}}
{{- define "oraclexe.selectorLabel" -}}
app.kubernetes.io/name: {{ include "oraclexe.name" . }}
{{- end }}

{{/*
[08] Commons Labels
*/}}
{{- define "oraclexe.labels" -}}
helm.sh/chart: {{ include "oraclexe.name" . }}
version: {{ include "oraclexe.appversion" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ include "oraclexe.appversion" . }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.openshift.io/runtime:  {{ .Values.app.name }}
{{ include "oraclexe.selectorLabels" . }}
{{- end }}

{{/*
[09] Custom Project Annotations
*/}}
{{- define "oraclexe.customProjectAnnotations" -}}
  {{- $version := (include "oraclexe.appversion" . | trimPrefix "\"" | trimSuffix "\"" ) -}}
  {{- $annotations := .Values.baseProjectAnnotations | default (dict) -}}
  {{- $annotations := set $annotations "app.kubernetes.io/version" $version -}}
  {{- $annotations := set $annotations "meta.helm.sh/chart"    .Chart.Name -}}
  {{- $annotations := set $annotations "meta.helm.sh/release"   .Release.Name -}}
  {{- $annotations := set $annotations "meta.helm.sh/revision"   (.Release.Revision | toString ) -}}
  {{- $annotations := set $annotations "meta.helm.sh/managed-by" .Release.Service -}}
{{- toYaml $annotations -}}
{{- end -}}
