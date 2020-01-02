require 'action_dispatch/routing/route_set'

module ActionDispatch
  module Routing
    class RouteSet #:nodoc:
      if ::Rails.version.to_f >= 4.2
        def url_for_with_subdomains(options, route_name = nil, url_strategy = UNKNOWN)
          if SubdomainFu.needs_rewrite?(options[:subdomain], (options[:host] || (@request && @request.host_with_port))) || options[:only_path] == false
            options[:only_path] = false if SubdomainFu.override_only_path?
            options[:host] = SubdomainFu.rewrite_host_for_subdomains(options.delete(:subdomain), options[:host] || (@request && @request.host_with_port))
          else
            options.delete(:subdomain)
          end
          url_for_without_subdomains(options, route_name, url_strategy)
        end
      else
        def url_for_with_subdomains(options, path_segments=nil)
          if SubdomainFu.needs_rewrite?(options[:subdomain], (options[:host] || (@request && @request.host_with_port))) || options[:only_path] == false
            options[:only_path] = false if SubdomainFu.override_only_path?
            options[:host] = SubdomainFu.rewrite_host_for_subdomains(options.delete(:subdomain), options[:host] || (@request && @request.host_with_port))
          else
            options.delete(:subdomain)
          end
          url_for_without_subdomains(options)
        end
      end
      
      alias_method: :url_for_with_subdomains, :url_for
      alias_method: :url_for, :url_for_with_subdomains
    end
  end
end
