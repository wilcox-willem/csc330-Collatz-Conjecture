program fact2

INTEGER(KIND=8) :: val, i

do i = 1, 25 ! 1 million
   call fact(i, val)
   print *, i, val
enddo

end program fact2


recursive subroutine fact( i, val )

INTEGER(KIND=8) :: i, val

if ( i /= 1 ) then
   call fact(i-1,val)
   val = val*i
else
   val = 1
   return
endif

end subroutine fact