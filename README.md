# BOSH Deployment Event Resource

A [Concourse](http://concourse.ci/) resource to trigger pipelines based on create/update/delete deployment events on a [BOSH](http://bosh.io) Director. The main use case is to trigger backup pipelines whenever there are deployment changes.

**Warning This resource is currently experimental. It can trigger your backup pipeline for no apparent reason or not trigger your backup despite numerous good reasons. Nevertheless, feel free to take it for a spin and let me know if it works for you!**

## Source Configuration

| Field  | Required | Type   | Description
|:-------|:--------:|:------:|:-----------
| target    | Y    | String | BOSH Director URL (eg. https://192.168.50.6:25555)
| client    | Y    | String | BOSH client (eg. admin)
| client_secret | Y| String | BOSH client's secret (password)
| ca_cert   | Y    | String | BOSH Director CA Cert (as you would provide for BOSH CLI)

## Behavior

### `check`: Returns the date of the most recent create/update/delete deployment event since the previous check (version).

### `in`: Does nothing.

### `out`: Does nothing.

## Example Configuration

### Resource Type

```yaml
resource_types:
- name: bosh-deployment-event-resource
  type: docker-image
  source:
    repository: mkuratczyk/bosh-deployment-event-resource
```

### Resource

``` yaml
resources:
- name: deployment-changes
  type: bosh-deployment-event-resource
  source:
    target: https://192.168.50.6:25555
    client: admin
    client_secret: password
    ca_cert: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
```

### Plan

This resource will only trigger your pipeline. You should have another task that perform the actual backup. Take a look [bbr-pcf-pipeline-tasks](https://github.com/pivotal-cf/bbr-pcf-pipeline-tasks) for an example.

``` yaml
jobs:
- name: backup
  plan:
  - get: deployment-changes
    trigger: true
  - task: actual-backup-task
    ...
```

## License

Apache License 2.0, see [LICENSE](LICENSE).