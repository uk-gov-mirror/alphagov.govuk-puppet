# Creates the igordealcantarabarroso user
class users::igordealcantarabarroso {
  govuk_user { 'igordealcantarabarroso':
    ensure   => 'absent',
    fullname => 'Igor deAlcantaraBarroso',
    email    => 'igor.dealcantarabarroso@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYr6elwwzR3Xbim2k/SXiIVnJkCkOpPpKvN0iKdMgDxuwH5kO55X3Hs6CtGWIxmOsVJmQoH0ugTx2tbhmUmGPCdtCr1E4V27jaRYN7jLE3y0815Uuk9uWeErpqiwkciJV+YuPqHqz8EzDPCNsPwr7uAethQ3PV8cjuJjcNNrOBDrZvcU2jIa3WKA3iRfeRPatzhdgZcNqKiekloVu/Apop7cqSBr0vPb0YEQ8ZtgO4ey0By85YJxFKvVv3ULx+OhGLIzYvd25TN9/timIHQ2V8ooYfddWujUD6XF1V0TWy8aQ2SY3jUOjjUZAd0ZCf+PWDVEUwNerIpQQycMPnhf3nMYfaVX75P7MH/93RV6DExb+GC/8hLV6sCWjL+RHHWio/+pvSDqe7eU4U2X1dlSJiyPguNrj8ZQlGLH7R2LzGecBYD73KuIDRv3+c9DtFYVzmeCUjosVDtkxclmQkspUkR8hQEoJ1iSyhI7+y7D8lh4bpznJ1ME22N08C8QlglL8LTC3c0abzF4qkTJM7gLwIXn+FoCwgSxUexYI1Kn3q19Oqm1jNwJgwiBpfbroM/fYs8xTE0koMszkog29VIy+eXqstqvoW94dt7mVH7/adGjYTcdKrUXdn2Al5SN67B4Hqost32awED7r6JscD+2fkmXHZDgBO8sFbO4CWWHbTwQ== igor.dealcantarabarroso@digital.cabinet-office.gov.uk',
  }
}
