# run packer (prints to stdout, but stores the output in a variable)
packer_out=$(packer build ../packer/aws-ubuntu.pkr.hcl | tee /dev/tty)

# packer prints the id of the generated AMI in its last line
ami=$(echo "$packer_out" | tail -c 30 | perl -n -e'/: (ami-.+)$/ && print $1')

# create the 'ami.tf' file from the template:
export AMI_GENERATED_BY_PACKER="$ami" && envsubst < ami.tf.template > ami.tf