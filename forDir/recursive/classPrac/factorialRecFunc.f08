program fact1

integer(KIND=8) :: val, i
integer(KIND=8) :: fact
external fact

do i = 1, 25
  print *, i, fact(i)
enddo

end program fact1


recursive integer(KIND=8) function fact( i ) result (val)

integer(KIND=8) :: i

if ( i /= 1 ) then
  val = i * fact(i-1)
else
  val = 1
  return
endif

end function fact