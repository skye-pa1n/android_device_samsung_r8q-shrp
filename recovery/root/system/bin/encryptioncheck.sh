#!/sbin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

mnt_vendor() {
    if mount | grep /vendor >/dev/null; then
        umount "/vendor"
    fi
    mkdir -p "/tmp/vendor";
    mount -r "/dev/block/mapper/vendor" "/tmp/vendor";
}

umnt_vendor() {
    if mount | grep /tmp/vendor >/dev/null; then
        umount "/tmp/vendor";
        rm -r "/tmp/vendor";
    fi
}

check_encryption_type() {
  local fbe_type=$(grep -o -m1 "fileencryption=ice" "/tmp/vendor/etc/fstab.qcom")
  if [ "$fbe_type" = "fileencryption=ice" ]; then
      resetprop --delete ro.crypto.volume.options
      resetprop ro.crypto.allow_encrypt_override true
  fi
}

mnt_vendor
check_encryption_type
umnt_vendor

exit 0;
