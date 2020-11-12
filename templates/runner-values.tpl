{{- define "runner_values" }}
{{- $defaultValues := `
CreateRbac: true
SkipClusterTest: true
RuntimeInCluster: true
` | fromYaml }}
{{- $_ := set $defaultValues "Namespace" .Release.Namespace }}  

{{- $secretValues := ( .Files.Get "secret-values.yaml" | fromYaml ) }}
{{- deepCopy $defaultValues | mergeOverwrite $secretValues | mergeOverwrite .Values | toYaml }}
{{- end }}

