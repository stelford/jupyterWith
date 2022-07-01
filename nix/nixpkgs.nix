let

  nixpkgs = fetchTarball "https://api.${nixpkgsLocked.host or "github.com"}/repos/${nixpkgsLocked.owner}/${nixpkgsLocked.repo}/tarball/${nixpkgsLocked.rev}";

in
  import nixpkgs
