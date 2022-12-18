# Dev Container Features

This repository holds my development container features.

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder.  Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```
├── src
│   ├── clusterctl
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
│   ├── kubeadm
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time.  Implementing tools are also free to process attributes under the `customizations` property as desired.

### Options

All available options for a Feature should be declared in the `devcontainer-feature.json`.  The syntax for the `options` property can be found in the [devcontainer Feature json properties reference](https://containers.dev/implementors/features/#devcontainer-feature-json-properties).

Options are exported as Feature-scoped environment variables.  The option name is captialized and sanitized according to [option resolution](https://containers.dev/implementors/features/#option-resolution).

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`.  Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

#### Using private Features in Codespaces

For any Features hosted in GHCR that are kept private, the `GITHUB_TOKEN` access token in your environment will need to have `package:read` and `contents:read` for the associated repository.

Many implementing tools use a broadly scoped access token and will work automatically.  GitHub Codespaces uses repo-scoped tokens, and therefore you'll need to add the permissions in `devcontainer.json`

An example `devcontainer.json` can be found below.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
     "ghcr.io/my-org/private-features/hello:1": {
            "greeting": "Hello"
        }
    },
    "customizations": {
        "codespaces": {
            "repositories": {
                "my-org/private-features": {
                    "permissions": {
                        "packages": "read",
                        "contents": "read"
                    }
                }
            }
        }
    }
}
```
