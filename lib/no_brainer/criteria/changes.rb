module NoBrainer::Criteria::Changes
  extend ActiveSupport::Concern

  def changes(*args)
    return finalized_criteria.changes(*args) unless finalized?

    # We won't do any instantiations with attributes for now.
    raise 'Please use .raw.changes()' unless raw?

    # We can't have implicit sorting as eager streams are not
    # supported by r.changes().
    criteria = self
    criteria = criteria.without_ordering if ordering_mode == :implicit
    run { criteria.to_rql.changes(*args) }
  end
end
