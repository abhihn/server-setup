# Installing GCC and other dependancies
package "gcc" do
  action :install
end

package "make" do
  action :install
end

package "libcurl-devel" do
  action :install
end

package "gcc-c++" do
  action :install
end