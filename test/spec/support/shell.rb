module Shell
  class Error < StandardError
    def initialize(cmd, code, output)
      @cmd = cmd
      @code = code
      @output = output
    end

    def message
      "command failed with code #{@code}: #{@cmd}\n#{@output}"
    end
  end

  # @param [String] cmd
  # @param [Hash] opts
  # @return [Kommando]
  def run(cmd, opts = {})
    opts[:output] = debug_kommando? unless opts.has_key?(:output)
    Kommando.run(cmd, opts)
  end

  # @param [String] cmd
  # @param [Hash] opts
  # @raise [Error]
  # @return [Kommando]
  def run!(cmd, **opts)
    run(cmd, **opts).tap do |k|
      raise Error.new(cmd, k.code, k.out) unless k.code.zero?
    end
  end

  # @param [String] cmd
  # @param [Hash] opts
  # @return [Kommando]
  def kommando(cmd, opts = {})
    opts[:output] = debug_kommando? unless opts.has_key?(:output)
    Kommando.new(cmd, opts)
  end

  def debug_kommando?
    ENV.has_key?('DEBUG_KOMMANDO')
  end
end