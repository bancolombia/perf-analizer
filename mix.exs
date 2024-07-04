defmodule DistributedPerformanceAnalyzer.MixProject do
  use Mix.Project

  def project do
    [
      app: :distributed_performance_analyzer,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: true,
      test_coverage: [
        tool: ExCoveralls,
        summary: [threshold: 90]
      ],
      deps: deps(),
      aliases: aliases(),
      metrics: true,
      package: package()
    ]
  end

  def cli do
    [
      preferred_envs: [
        release: :prod,
        coveralls: :test,
        "coveralls.multiple": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.xml": :test
      ]
    ]
  end

  defp aliases do
    case Mix.env() do
      :dev -> [compile: "do compile, git_hooks.install"]
      _ -> []
    end
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    extra_applications =
      case Mix.env() do
        :dev ->
          [:logger, :opentelemetry_exporter, :opentelemetry, :eex, :wx, :observer, :runtime_tools]

        _ ->
          [:logger, :opentelemetry_exporter, :opentelemetry]
      end

    [
      extra_applications: extra_applications,
      included_applications: [:mnesia],
      mod: {DistributedPerformanceAnalyzer.Application, [Mix.env()]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sobelow, "~> 0.13", only: :dev},
      {:credo_sonarqube, "~> 0.1"},
      {:finch, "~> 0.1"},
      {:opentelemetry_plug,
       git: "https://github.com/juancgalvis/opentelemetry_plug.git", tag: "master"},
      {:opentelemetry_api, "~> 1.0"},
      {:opentelemetry_exporter, "~> 1.0"},
      {:telemetry, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics_prometheus, "~> 1.0"},
      {:castore, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:plug_checkup, "~> 0.6"},
      {:poison, "~> 5.0"},
      {:cors_plug, "~> 3.0"},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_unit_sonarqube, "~> 0.1", only: :test},
      {:constructor, "~> 1.0"},
      {:nimble_csv, "~> 1.0"},
      {:file_size, "~> 3.0"},
      {:mint, "~> 1.0"},
      {:tesla, "~> 1.0"},
      {:git_hooks, "~> 0.7", only: [:dev], runtime: false},
      {:benchee, "~> 1.0", only: [:dev, :test]},
      {:benchee_html, "~> 1.0", only: [:dev, :test]},
      {:poolboy, "~> 1.5"}
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "distributed_performance_analyzer",
      # The organization the package belongs to. The package will be published to the organization repository, defaults = i"hexpm" repository.
      organization: "bancolombia",
      files: ["assets", "config", "hooks", "lib", "rel", "test", "Dockerfile", "LICENSE", "SECURITY.md", "README.md", "coveralls.json", "mix.lock", "mix.exs", "sonar-project.properties", ".formatter.exs", ".credo.exs", ".gitignore", ".dockerignore"],
      maintainers: ["Brayan Batista Zúniga", "Alejandro Jose Tortolero Machado", "Juan David Giraldo Marin"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/bancolombia/distributed-performance-analyzer.git"}
    ]
  end
end
