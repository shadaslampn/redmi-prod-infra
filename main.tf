#---------------#
#    Keypair    #		
#---------------#

resource "aws_key_pair" "auth_key" {
  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("zomato.pub")
  tags = {
    Name = "${var.project_name}-${var.project_env}"
  }
}
