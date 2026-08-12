# The JS bundle lives in public/builds rather than the asset pipeline so that
# esbuild's code-split chunks stay reachable at the paths baked into the code.
# That puts cache busting on us: bin/build-js hashes the entrypoint filename and
# records it in a manifest we read here.
module JavascriptHelper
  MANIFEST_PATH = Rails.root.join("public", "builds", "manifest.json")

  def javascript_bundle_tag(name, **options)
    javascript_include_tag javascript_bundle_path(name), type: "module", **options
  end

  def javascript_bundle_path(name)
    file = "#{name}.js"

    path = javascript_bundle_manifest[file]
    raise "#{file} is missing from #{MANIFEST_PATH}. Run bin/build-js." if path.nil?

    path
  end

  private

  def javascript_bundle_manifest
    JavascriptHelper.manifest
  end

  class << self
    # Rebuilds change the hash, so development has to reread every request.
    def manifest
      return read_manifest if Rails.env.development?

      @manifest ||= read_manifest
    end

    private

    def read_manifest
      JSON.parse(MANIFEST_PATH.read)
    rescue Errno::ENOENT
      raise "#{MANIFEST_PATH} is missing. Run bin/build-js."
    end
  end
end
