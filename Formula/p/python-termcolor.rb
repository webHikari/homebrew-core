class PythonTermcolor < Formula
  desc "ANSI color formatting for output in terminal"
  homepage "https://github.com/termcolor/termcolor"
  url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
  sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f182f2018a5533bdb094af2ab939b0943f079d287d318e1694f4b83aa7e29fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "455291ea47180f3f9e62ace232df0a010cf2dbe38e3a7469e3570158b81060b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ba2fe70833e494e0cdeca79fa0d9d8a2b5074e4630f484413b38209de83cb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "74dd75dab12cb34068b723dcce9eb49bfa920a4d3cdb772df7b71acd1c2db14e"
    sha256 cellar: :any_skip_relocation, ventura:        "e7364c03c54c4b442b3ea545c8149ca0a0c1ade696e4bd63095fbb1c713258e0"
    sha256 cellar: :any_skip_relocation, monterey:       "425d7252471829fa2a13fff76589ae0eda3a213e42f6b15210499dc2f8cd1ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77462ea68e2d9e2a2fa2890baeef9af1359dfef8c8cb34797a1ac88f60b15ad"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import termcolor"
    end
  end
end
