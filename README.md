# nf-humann

A simple nextflow DSL2 pipeline to run [humann](https://github.com/biobakery/humann) from `fastq` files

# . pipeline parameters

## Input/output options

Define where the pipeline should find input data and save output data.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `input` | Path to Fastq files <details><summary>Help</summary><small>For example: --input /path/to/*.R{1,2}.fastq.gz
</small></details>| `string` |  |  |  |
| `outdir` | The output directory where the results will be saved. You have to use absolute paths to storage on Cloud infrastructure. | `string` | results |  |
|
| `nucleotide_db` | Path to HUMANN nucleotide db <details><summary>Help</summary><small>Databases and their path should be created with humann. See
<https://github.com/biobakery/humann></small></details>| `string` |  |  |  |
| `protein_db` | Path to HUMANN protein db <details><summary>Help</summary><small>Databases and their path should be created with humann. See
<https://github.com/biobakery/humann></small></details>| `string` |  |  |  |

## Institutional config options

Parameters used to describe centralised config profiles. These should not be edited.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `custom_config_version` | Git commit id for Institutional configs. | `string` | master |  | True |
| `custom_config_base` | Base directory for Institutional configs. <details><summary>Help</summary><small>If you're running offline, Nextflow will not be able
to fetch the institutional config files from the internet. If you don't need them, then this is not a problem. If you do need them, you should download the
files from the repo and tell Nextflow where to find them with this parameter.</small></details>| `string` |
<https://raw.githubusercontent.com/nf-core/configs/master> |  | True |

## Max job request options

Set the top limit for requested resources for any single job.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `max_cpus` | Maximum number of CPUs that can be requested for any single job. <details><summary>Help</summary><small>Use to set an upper-limit for the CPU
requirement for each process. Should be an integer e.g. `--max_cpus 1`</small></details>| `integer` | 16 |  | True |
| `max_memory` | Maximum amount of memory that can be requested for any single job. <details><summary>Help</summary><small>Use to set an upper-limit for the
memory requirement for each process. Should be a string in the format integer-unit e.g. `--max_memory '8.GB'`</small></details>| `string` | 128.GB |  | True |
| `max_time` | Maximum amount of time that can be requested for any single job. <details><summary>Help</summary><small>Use to set an upper-limit for the time
requirement for each process. Should be a string in the format integer-unit e.g. `--max_time '2.h'`</small></details>| `string` | 240.h |  | True |

## Generic options

Less common options for the pipeline, typically set in a config file.

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `tracedir` | Directory to keep pipeline Nextflow logs and reports. | `string` | ${params.outdir}/pipeline_info |  | True |
| `enable_conda` | Run this workflow with Conda. You can also use '-profile conda' instead of providing this parameter. | `boolean` |  |  | True |
