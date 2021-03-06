# frozen_string_literal: true

require 'ruby-nessus/version2/port'

module RubyNessus
  module Version2
    class Event
      def initialize(event)
        @event = event
      end

      #
      # Return the event port.
      #
      # @return [Object]
      #    Return the event port object or port string.
      #
      # @example
      #   event.port            #=> "https (443/tcp)"
      #   event.port.number     #=> 443
      #   event.port.service    #=> "https"
      #   event.port.protocol   #=> "tcp"
      #
      def port
        @port ||= Port.new(@event.at('@port'), @event.at('@svc_name'), @event.at('@protocol'))
      end

      #
      # Return the event severity.
      #
      # @return [String]
      #    Return the event severity.
      #
      # @example
      #   event.severity          #=> 3
      #
      def severity
        @severity ||= @event.at('@severity').inner_text.to_i
      end

      #
      # Return true if event is of informational severity.
      #
      # @return [Boolean]
      #    Return true if the event is informational.
      #
      def informational?
        severity == 0
      end

      #
      # Return true if the event is of low severity.
      #
      # @return [Boolean]
      #   Return true if the event is low severity.
      #
      def low?
        severity == 1
      end

      #
      # Return true if the event is of medium severity.
      #
      # @return [Boolean]
      #   Return true if the event is medium severity.
      #
      def medium?
        severity == 2
      end

      #
      # Return true if the event is of high severity.
      #
      # @return [Boolean]
      #   Return true if the event is high severity.
      #
      def high?
        severity == 3
      end

      #
      # Return true if the event is of critical severity.
      #
      # @return [Boolean]
      #   Return true if the event is critical severity.
      #
      def critical?
        severity == 4
      end

      #
      # Return the event object nessus plugin id
      #
      # @return [String]
      #    Return the event object nessus plugin id
      #
      # @example
      #   event.plugin_id #=> 3245
      #
      def id
        @plugin_id ||= @event.at('@pluginID').inner_text.to_i
      end
      alias plugin_id id

      #
      # Return the event object plugin family name.
      #
      # @return [String]
      #   Return the event object plugin family name.
      #
      # @example
      #   event.family #=> "Service detection"
      #
      def family
        @plugin_family ||= @event.at('@pluginFamily').inner_text
      end
      alias plugin_family family

      #
      # Return the event name (plugin_name)
      #
      # @return [String, nil]
      #    Return the event name (plugin_name)
      #
      # @example
      #   event.plugin_name   #=> "PHP < 5.2.4 Multiple Vulnerabilities"
      #   event.name          #=> "PHP < 5.2.4 Multiple Vulnerabilities"
      #
      def plugin_name
        @plugin_name ||= @event.at('@pluginName')&.inner_text unless @event.at('@pluginName').inner_text.empty?
      end
      alias name plugin_name

      #
      # Return the event synopsis.
      #
      # @return [String, nil]
      #    Return the event synopsis.
      #
      def synopsis
        @synopsis ||= @event.at('synopsis')&.inner_text
      end

      #
      # Return the event description.
      #
      # @return [String, nil]
      #    Return the event description.
      #
      def description
        @description ||= @event.at('description')&.inner_text
      end

      #
      # Return the event solution.
      #
      # @return [String, nil]
      #    Return the event solution.
      #
      def solution
        @solution ||= @event.at('solution')&.inner_text
      end

      #
      # Return the event risk.
      #
      # @return [String, nil]
      #    Return the event risk.
      #
      def risk
        @risk_factor ||= @event.at('risk_factor')&.inner_text
      end

      #
      # Return the event plugin output.
      #
      # @return [String, nil]
      #    Return the event plugin output.
      #
      def output
        @plugin_output ||= @event.at('plugin_output')&.inner_text
      end
      alias data output
      alias plugin_output output

      #
      # Return the event plugin version.
      #
      # @return [String, nil]
      #    Return the event plugin version.
      #
      def version
        @plugin_version ||= @event.at('plugin_version')&.inner_text
      end
      alias plugin_version version

      #
      # Return the event reference links.
      #
      # @return [Array<String>]
      #    Return the event reference links.
      #
      def see_also
        unless @see_also
          @see_also = []
          @event.xpath('see_also').each do |see_also|
            @see_also << see_also.inner_text
          end
        end
        @see_also
      end
      alias links see_also
      alias more see_also
      alias references see_also

      #
      # Return the event patch publication date.
      #
      # @return [String, nil]
      #    Return the event patch publication date.
      #
      def patch_publication_date
        @patch_publication_date ||= Time.parse(@event.at('patch_publication_date').inner_text + ' UTC') if @event.at('patch_publication_date')
      end

      #
      # Return the event cvss base score.
      #
      # @return [String, nil]
      #    Return the event cvss base score.
      #
      def cvss_base_score
        @cvss_base_score ||= @event.at('cvss_base_score')&.inner_text.to_f
      end

      #
      # Return the event cve.
      #
      # @return [Array<String>, nil]
      #    Return the event cvss base score.
      #
      def cve
        unless @cve
          @cve = []
          @event.xpath('cve').each do |cve|
            @cve << cve.inner_text
          end
          @cve = nil if @cve.empty?
        end
        @cve
      end

      #
      # Return the event bid.
      #
      # @return [Array<String>, nil]
      #    Return the event bid.
      #
      def bid
        unless @bid
          @bid = []
          @event.xpath('bid').each do |bid|
            @bid << bid.inner_text
          end
          @bid = nil if @bid.empty?
        end
        @bid
      end

      #
      # Return other event related references.
      #
      # @return [Array<String>]
      #    Return the event related references.
      #
      def xref
        unless @xref
          @xref = []
          @event.xpath('xref').each do |xref|
            @xref << xref.inner_text
          end
        end
        @xref
      end

      #
      # Return other event cvss vector.
      #
      # @return [String, nil]
      #    Return the event cvss vector.
      #
      def cvss_vector
        @cvss_vector ||= @event.at('cvss_vector')&.inner_text
      end

      #
      # Return the event cpe.
      #
      # @return [Array<String>]
      #    Return the event cpe.
      #
      def cpe
        unless @cpe
          @cpe = []
          @event.xpath('cpe').each do |cpe|
            @cpe << cpe.inner_text
          end
        end
        @cpe
      end
    end
  end
end
