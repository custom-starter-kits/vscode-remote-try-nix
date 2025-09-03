# Nix

[![Nix](../../actions/workflows/nix.yaml/badge.svg)](../../actions/workflows/nix.yaml)

This project serves as a foundational template for integrating Nix, Dev Containers, and GitHub Actions into your development workflow. It provides a robust and reproducible environment, ideal for both new users exploring declarative development and experienced practitioners seeking streamlined setups.

## ⚙️ Getting Started

To begin, ensure your system has the following prerequisites installed:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Visual Studio Code (VS Code)**: [Download VS Code](https://code.visualstudio.com/)
- **Dev Containers Extension**: Install from the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Clone the Repository

Clone the repository from GitHub:

```bash
git clone https://github.com/custom-starter-kits/vscode-remote-try-nix.git
```

### Verify Docker is Running

Make sure Docker is running on your machine. You can verify this by opening a terminal and running:

```bash
docker --version
```

> [!NOTE]
> If Docker is not running, start the Docker or Docker Desktop application on your computer.

### Open the Repository

Then open the cloned repository in **Visual Studio Code**.

```bash
code vscode-remote-try-nix
```

### Reopen in Container

When prompted, click **Reopen in Container**. VS Code will build the container and drop you into a fully configured containerized development environment.

---

## 💻 Using Nix

### 🧪 Try the Sample Script

Run the included script to see Nix in action:

```bash
./.nix/ci/workflows/nix.sh
```

You should see a rainbow-colored cow say something nice about Nix 😄

```
 _________________
< Nix is awesome! >
 -----------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

---

### 🧩 Adding New Packages

To add a new package to your environment:

1. Browse https://search.nixos.org/packages?channel=unstable to find the package you want to add.

2. Open `flake.nix`

3. Add the package to one or both of these lists:
   - `installNixPackages`: for packages used in scripts and the terminal
   - `installNixProfilePackages`: for packages installed globally via `nix profile install`

Example:

```nix
installNixPackages = pkgs: [
  pkgs.nodejs
  pkgs.python3
];

installNixProfilePackages = pkgs: [
  pkgs.nixd
  pkgs.nixfmt-rfc-style
];
```

The Dev Container will automatically install these when it starts. To restart a Dev Container manually type `F1` and type `> Dev Containers: Rebuild Without Cache and Reopen in Container`.

---

### 🧪 Try Packages Temporarily

Want to test a package without editing `flake.nix`?

```bash
nix shell nixpkgs#nodejs nixpkgs#python3
```

This opens a temporary shell with [`nodejs`](https://nodejs.org) and [`python`](https://python.org) installed. You can run:

```bash
node --version
> v22.18.0

python --version
> Python 3.13.6
```

Once you're done, type `exit`. The packages will no longer be available outside that shell:

```bash
node --version
> bash: node: command not found

python --version
> bash: python: command not found
```

---

### 🔄 Updating Packages

To update the packages defined in `flake.nix`, run:

```bash
nix flake update
```

## ❔ Frequently Asked Questions (FAQ)

### What is Nix?

Nix is a powerful package manager for Linux and other Unix systems that makes package management reliable and reproducible. It is a [Core Component of the Nix Ecosystem](https://wiki.nixos.org/wiki/Nix_ecosystem).

### How does Nix ensure reproducibility?

Nix uses a unique approach to package management by isolating dependencies and using cryptographic hashes to ensure that builds are reproducible.

### Why does Nix use hash-based versioning instead of [semver](https://semver.org)-based versioning?

Nix employs **hash-based versioning** to guarantee reproducibility, security, and integrity across development environments. Unlike **semantic versioning** (e.g., `1.2.3`), Nix pins packages to **cryptographic hashes**, not mutable identifiers.

#### What's a Hash?

A [Hash](https://en.wikipedia.org/wiki/Cryptographic_hash_function) acts as a unique digital fingerprint for any piece of data. Even the tiniest change results in an entirely different hash.

**Examples:**

SHA256 Hash of a file with `Hello world`:

```bash
echo "Hello world" | sha256sum
> 1894a19c85ba153acbf743ac4e43fc004c891604b26f8c69e1e83ea2afc7c48f  -
```

SHA256 Hash of a file with `Hello World`:

```bash
echo "Hello World" | sha256sum
> d2a84f4b8b650937ec8f73cd8be2c74add5a911ba64df27458ed8229da804a26  -
```

See the difference? One tiny letter change, and the hash is totally different.

#### Why Hashes Are Powerful (And Secure)

Hashes are fundamental to content identification and protection.

**Example**: 

1. Consider the [gum](https://github.com/charmbracelet/gum) project on GitHub.
2. This package is currently fetched by Nix from GitHub using the Git tag `v0.16.0` - see [here](https://github.com/NixOS/nixpkgs/blob/d7600c775f877cd87b4f5a831c28aa94137377aa/pkgs/by-name/gu/gum/package.nix#L13).
3. The Git tag `v0.16.0` currently resolves to the Git commit [`0d116b80685eff038aa0d436c87e4f08760ad357`](https://github.com/charmbracelet/gum/commit/0d116b80685eff038aa0d436c87e4f08760ad357) - see [here](https://github.com/charmbracelet/gum/releases/tag/v0.16.0).
4. However, Git tags can be deleted and reassigned; an attacker could redirect `v0.16.0` to a potentially malicious commit.
5. Therefore, relying solely on tags risks installing compromised software.

Nix mitigates this by validating downloaded content against its expected hash - see [here](https://github.com/NixOS/nixpkgs/blob/d7600c775f877cd87b4f5a831c28aa94137377aa/pkgs/by-name/gu/gum/package.nix#L17). If, in the future, the hashes do not match, Nix refuses to install the package, preventing supply chain attacks.

#### Chain of Trust with `flake.lock`

All Nix Flake inputs (here `github:NixOS/nixpkgs/nixos-unstable`) are [pinned](https://zero-to-nix.com/concepts/pinning/) to a specific Git commit in a lockfile called `flake.lock`. This file stores this information as JSON.

The `flake.lock` file ensures that Nix flakes have purely deterministic outputs. A `flake.nix` file without an accompanying `flake.lock` should be considered incomplete and a kind of proto-flake. Any Nix CLI command that is run against the flake — like `nix build`, `nix develop`, or even `nix flake show` — generates a `flake.lock` for you.

Here is the current `flake.lock` file that pins [Nixpkgs](https://github.com/NixOS/nixpkgs) to a specific Git commit:

```json
{
  "nodes": {
    "nixpkgs": {
      "locked": {
        "lastModified": 1756542300,
        // A SHA256 hash of the contents of the flake
        "narHash": "sha256-tlOn88coG5fzdyqz6R93SQL5Gpq+m/DsWpekNFhqPQk=",
        // The GitHub organization
        "owner": "NixOS",
        // The GitHub repository
        "repo": "nixpkgs",
        // The specific Git commit
        "rev": "d7600c775f877cd87b4f5a831c28aa94137377aa",
        // The type of input
        "type": "github"
      },
      "original": {
        "owner": "NixOS",
        "ref": "nixos-unstable",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "root": {
      "inputs": {
        "nixpkgs": "nixpkgs"
      }
    }
  },
  "root": "root",
  "version": 7
}
```

If this `flake.lock` were alongside a `flake.nix` with this input block…

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    # Define outputs here
  };
}
```

... the `nixpkgs` attribute would be implicitly pinned to the latest `de60d387a0e5737375ee61848872b1c8353f945e` Git commit of the `NixOS/nixpkgs/nixos-unstable` Git branch — even though that information isn't defined in the Nix code itself.

Therefore, by using a `flake.lock` file, a [Chain of Trust](https://en.wikipedia.org/wiki/Chain_of_trust) is created between the `flake.nix` file and all its dependencies. This ensures that builds are both reproducible and secure, now and over the long term.

## 📖 Documentation

Below you will find a list of documentation for tools used in this project. 

- **Nix**: Nix Package Manager - [Docs](https://wiki.nixos.org/wiki/Nix) 
- **Nix Flakes**: An Experimental Feature for Managing Dependencies of Nix Projects - [Docs](https://wiki.nixos.org/wiki/Flakes)
- **GitHub Actions**: Automation and Execution of Software Development Workflows - [Docs](https://docs.github.com/en/actions) 

---

## 🐛 Found a Bug? 

Thank you for your message! Please fill out a [bug report](../../issues/new?assignees=&labels=&template=bug_report.md&title=). 

## 📖 License 

This project is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.txt).