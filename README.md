[![Tests](https://github.com/Roblox/performance-benchmarking-lua/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/Roblox/performance-benchmarking-lua/actions?query=workflow%3ATests+branch%3Amain)

# Performance Benchmarking Lua

## Getting started
---

### Rust

(optional section)

Foreman toolchain manager uses Rust so you might want to install it first. Go to the [official installation instructions](https://www.rust-lang.org/tools/install) to get installation steps for your platform

We can use `cargo` to install other required packages. It's a package manager for Rust so it's like `npm` in the Rust world.

Ensure `cargo` is available in your `PATH`:

```bash
cargo --version
cargo --help
```

### Foreman

You can grab the foreman's binary from the foreman [GitHub releases section](https://github.com/Roblox/foreman/releases)

We can also use `cargo` to install `foreman` (requires [Rust installation](#rust))

```bash
cargo install foreman
```

Verify the installation:

```bash
foreman --version
foreman --help
```

### GitHub API Key

We need GitHub API key to fetch tools that are private to Roblox. Generate a new access token:

GitHub > Settings > Developer > [Personal Access Tokens](https://github.com/settings/tokens)

Set scopes:

* [x] repo
   * [x] workflow
   * packages
     * [x] read:packages

![scopes example](./.github/assets/scopes.png)

### In a repository

- **Install using foreman**

    Forman installs toolchain packages from github repos based on the `forman.toml`

    In a repo you're working with:

    ```bash
    foreman github-api <github_api_key>
    foreman install
    ```

    Add foreman install directory to your `PATH`

    ```bash
    export PATH=$PATH:$HOME/.foreman/bin
    ```

- **Install using [Rotriever](https://github.com/Roblox/rotriever)**

    Rotrieve installs packages (similar to npm) from github repos based on the `rotriever.toml`

    ```bash
    rotrieve --git-auth <username>@<github_api_key> install


    # syntax for Rotriever version >= 5
    # rotrieve install --auth https://<username>:<github_api_key>@github.com
    ```

    If you fall out of sync, your `rotriever.lock` file tags to a specific sha - you can call:

    ```bash
    rotrieve --git-auth <username>@<github_api_key> upgrade


    # syntax for Rotriever version >= 5
    # rotrieve upgrade --auth https://<username>:<github_api_key>@github.com
    ```

    **Note**: If you get the following error on mac

    > dyld: Library not loaded: /usr/local/opt/openssl@1.1/lib/libssl.1.1.dylib Referenced from: ~/.foreman/tools/roblox__rotriever-0.4.3 Reason: image not found

    You can install using brew:

    ```bash
    brew install openssl@1.1
    ```

    This doesn't seem to work on Apple Silicon Macs 😞

## Running tests

```bash
./bin/ci-tests.sh
```

## Running benchmarks in Roblox CLI
---

### **Concurrent example**

First you need to build the project

```bash
rojo build ci.project.json --output ci.rbxm
```

### Time to first render benchmark

```bash
roblox-cli run --load.model ci.rbxm --run scripts/run-first-render-benchmark.lua --headlessRenderer 1
```
### FPS benchmark

```bash
roblox-cli run --load.model ci.rbxm --run scripts/run-frame-rate-benchmark.lua --headlessRenderer 1
```

If you want to run all examples at once there is a script to to that:

```bash
./bin/ci-benchmarks.sh
```

### **React Native Web benchmarks example**

---

<div align="center">Coming soon...</div>

---


## Running benchmarks in Roblox Studio
---

### **Concurrent example**

The easiest way to run the example in Roblox Studio is to sync files using [Rojo](https://rojo.space/).

### Start Rojo server

```bash
rojo serve concurrent.project.json
```

### Roblox Studio

In Roblox Studio:
- Open project with an empty baseplate
- Using [Rojo plugin](https://rojo.space/docs/installation/#installing-the-plugin) connect to the Rojo server you've created

![Rojo connect](./.github/assets/rojo-connect.png)
![Rojo connected](./.github/assets/rojo-connected.png)

- Click Play button (or F5)

### **React Native Web benchmarks example**

---

<div align="center">Coming soon...</div>

---
