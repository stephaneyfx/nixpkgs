{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, sq }:
buildGoModule rec {
  pname = "sq";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "neilotoole";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x5NHMTyOZSGOnAUCRu1qZggU5m832TFrBTSNJU6DUKo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorSha256 = "sha256-OHgdvitHi2f/svn0QDlknmteii+5rLKaZ7f7VJ+7H4w=";

  # Some tests violates sandbox constraints.
  doCheck = false;

  ldflags = [
    "-s" "-w" "-X github.com/neilotoole/sq/cli/buildinfo.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd sq \
      --bash <($out/bin/sq completion bash) \
      --fish <($out/bin/sq completion fish) \
      --zsh <($out/bin/sq completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion { package = sq; };
  };

  meta = with lib; {
    description = "Swiss army knife for data";
    homepage = "https://sq.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
