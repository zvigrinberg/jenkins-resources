package ocp.annotations_notset

import data.lib.konstraint.core as konstraint_core
import data.lib.openshift

violation[msg] {
  openshift.is_pod_or_networking

  not is_annotations_set(konstraint_core.resource.metadata)

  msg := konstraint_core.format_with_id(sprintf("%s/%s: does not have 'metadata.annotations' set", [konstraint_core.kind, konstraint_core.name]), "policy_id")
}

is_annotations_set(metadata) {
  metadata["annotations"]
}