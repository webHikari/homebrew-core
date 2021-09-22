require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.22.0.tgz"
  sha256 "69194d5d4ea68e6de101a12332e1484e211ff07a299f1fcf1736e91332a634e7"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4dd71c228058ccb1d8d5228bfe2e185f56b6bf3319bc0eb7a869063061a5d865"
    sha256 cellar: :any,                 big_sur:       "23444487c2d7cf59ac07501c52fe8a93811176242d7a46c4a24fa28fe00cf8a6"
    sha256 cellar: :any,                 catalina:      "23444487c2d7cf59ac07501c52fe8a93811176242d7a46c4a24fa28fe00cf8a6"
    sha256 cellar: :any,                 mojave:        "23444487c2d7cf59ac07501c52fe8a93811176242d7a46c4a24fa28fe00cf8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86610b38b79b8f02a9ab65c5f8f93462720754d335118ee9a955fd58d17c6623"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--chromedriver-skip-install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete obsolete module appium-ios-driver, which installs universal binaries
    rm_rf libexec/"lib/node_modules/appium/node_modules/appium-ios-driver"
  end

  plist_options manual: "appium"

  service do
    run opt_bin/"appium"
    environment_variables PATH: std_service_path_env
    run_type :immediate
    keep_alive true
    error_log_path var/"log/appium-error.log"
    log_path var/"log/appium.log"
    working_dir var
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
