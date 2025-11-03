{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bitcoind.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitcoind.fullname" -}}
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
{{- define "bitcoind.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Function to retrieve the bitcoin network, will be one of "mainnet", "testnet", "signet" or "regtest"
*/}}
{{- define "network" -}}
	{{- printf "%s" .Values.configuration.network | default "mainnet" }}
{{- end -}}

{{/*
Function to retrieve the secret name containing the RPC password
Handles three cases:
1. External Secrets is enabled - use ESO-generated secret
2. User provided an existing secret reference - use that
3. Default - use chart-generated secret
*/}}
{{- define "bitcoind.rpcPasswordSecretName" -}}
{{- if .Values.externalSecrets.enabled -}}
{{- printf "eso-%s" (include "bitcoind.fullname" .) -}}
{{- else if .Values.existingSecret -}}
{{- .Values.existingSecret -}}
{{- else -}}
{{- include "bitcoind.name" . -}}
{{- end -}}
{{- end -}}
