module Houston::Commits
  class Configuration


    def version_control(adapter, &block)
      raise ArgumentError, "#{adapter.inspect} is not a VersionControl: known VersionControl adapters are: #{Houston::Adapters::VersionControl.adapters.map { |name| ":#{name.downcase}" }.join(", ")}" unless Houston::Adapters::VersionControl.adapter?(adapter)
      raise ArgumentError, "version_control should be invoked with a block" unless block_given?

      configuration = HashDsl.hash_from_block(block)

      @version_control_configuration ||= {}
      @version_control_configuration[adapter] = configuration
    end

    def version_control_configuration(adapter)
      raise ArgumentError, "#{adapter.inspect} is not a VersionControl: known VersionControl adapters are: #{Houston::Adapters::VersionControl.adapters.map { |name| ":#{name.downcase}" }.join(", ")}" unless Houston::Adapters::VersionControl.adapter?(adapter)

      @version_control_configuration ||= {}
      @version_control_configuration[adapter] || {}
    end


    def github(&block)
      @github_configuration = HashDsl.hash_from_block(block) if block_given?
      @github_configuration ||= {}
    end

    def supports_pull_requests?
      github[:organization].present?
    end





    def identify_committers(commit=nil, &block)
      if block_given?
        @identify_committers_proc = block
      elsif commit
        @identify_committers_proc ? Array(@identify_committers_proc.call(commit)) : [commit.committer_email]
      end
    end

  end
end
