#
# Settings
#

IMAGE ?= $(CURDIR)/fedora-cloud-39.img

TF_APPLY_ARGS := $(TF_APPLY_EXTRA_ARGS)
TF_APPLY_ARGS += -var primary_image_url=$(IMAGE)

ifneq ($(shell command -v tf),)
	TERRAFORM := tf
else ifneq ($(shell command -v tofu),)
	TERRAFORM := tofu
else
	$(error terraform/opentofu not found!)
endif

#
# Helpers
#

.PHONY: init
init:
	$(TERRAFORM) init -upgrade

.PHONY: plan
plan: init
	$(TERRAFORM) plan

.PHONY: apply
apply:
	$(TERRAFORM) apply -auto-approve $(TF_APPLY_ARGS)

.PHONY: restart
restart:
	$(TERRAFORM) apply -auto-approve $(TF_APPLY_ARGS) -var node_names='[]'
	$(MAKE) apply

.PHONY: destroy
destroy:
	$(TERRAFORM) apply -auto-approve -destroy

#
# Downloads
#

.PHONY: clean-images
clean-images:
	rm -rf *.img *.qcow2

debian-cloud-12.qcow2:
	wget -O $@ https://cloud.debian.org/images/cloud/bookworm-backports/daily/latest/debian-12-backports-nocloud-amd64-daily.qcow2

fedora-cloud-39.img:
	wget -O $@.xz https://download.fedoraproject.org/pub/fedora/linux/releases/39/Cloud/x86_64/images/Fedora-Cloud-Base-39-1.5.x86_64.raw.xz
	unxz -T0 $@.xz
