# frozen_string_literal: true
module NETSNMP
  # Abstracts the OID structure
  #
  module OID
    OIDREGEX = /^[\d\.]*$/

    extend self

    def build(o)
      case o
      when OID then o
      when Array
        o.join('.')
      when OIDREGEX
        o = o[1..-1] if o.start_with?('.')
        o
      # TODO: MIB to OID
      else raise Error, "can't convert #{o} to OID"
      end
    end

    def to_asn(oid)
      OpenSSL::ASN1::ObjectId.new(oid)
    end

    # @param [OID, String] child oid another oid
    # @return [true, false] whether the given OID belongs to the sub-tree
    #
    def parent?(parent_oid, child_oid)
      child_oid.match(%r/\A#{parent_oid}\./)
    end
  end
end
