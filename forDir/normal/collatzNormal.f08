module CollatzModule
    implicit none

    type :: Result
        integer(kind=8) :: input, output
    end type Result

contains

    subroutine sortTopTen(topResults, sortType)
        type(Result), intent(inout) :: topResults(10)
        logical, intent(in) :: sortType
        integer :: i, j
        type(Result) :: temp

        do j = 1, size(topResults) - 1
            do i = j + 1, size(topResults)
                if (sortType) then
                    if (compareResults(topResults(j), topResults(i))) then
                        temp = topResults(j)
                        topResults(j) = topResults(i)
                        topResults(i) = temp
                    end if
                else
                    if (compareInputs(topResults(j), topResults(i))) then
                        temp = topResults(j)
                        topResults(j) = topResults(i)
                        topResults(i) = temp
                    end if
                end if
            end do
        end do
    end subroutine sortTopTen

    subroutine updateTopResults(topResults, x, y, cycles)
        type(Result), intent(inout) :: topResults(10)
        integer(kind=8), intent(in) :: x, y, cycles

        type(Result) :: newResult, minResult
        logical :: newResultFits, outputExistsAlready
        integer :: i, minIndex

        newResult = Result(x, y)
        minResult = newResult ! assume newResult is min
        newResultFits = .false.
        outputExistsAlready = .false.
        minIndex = 0
        

        do i = 1, size(topResults)
            if (topResults(i)%output < newResult%output) then
                newResultFits = .true.
            end if
            if (topResults(i)%output == newResult%output .and. topResults(i)%input < newResult%input) then
                outputExistsAlready = .true.
            end if

            if (topResults(i)%output < minResult%output) then
                minResult = topResults(i)
                minIndex = i
            end if
        end do

        ! Add the new item into topResults
        if ((newResultFits .or. cycles < 10) .and. .not. outputExistsAlready) then
            topResults(minIndex) = newResult
            call sortTopTen(topResults, .true.)
        end if

        ! Keep only the top 10 results
        if (size(topResults) > 10) then
            topResults = topResults(1:10)
        end if

    end subroutine updateTopResults

    subroutine printResults(topResults)
        type(Result), intent(inout) :: topResults(:)
        integer :: i

        ! Print top 10 based on sequence length
        print *, "Sorted based on sequence length"
        do i = size(topResults), 1, -1
            write(*, '(2I20)') topResults(i)%input, topResults(i)%output
        end do

        ! Print top 10 based on input length
        call sortTopTen(topResults, .false.)
        print *, "Sorted based on integer length"
        do i = 1, size(topResults)
            write(*, '(2I20)') topResults(i)%input, topResults(i)%output
        end do
    end subroutine printResults

    logical function compareResults(a, b)
        type(Result), intent(in) :: a, b

        if (a%output > b%output) then
            compareResults = .true.
        else if (a%output == b%output .and. a%input < b%input) then
            compareResults = .true.
        else
            compareResults = .false.
        end if
    end function compareResults

    logical function compareInputs(a, b)
        type(Result), intent(in) :: a, b

        compareInputs = (a%input < b%input)
    end function compareInputs

     ! Function to calculate the number of sequences
    integer(kind=8) function collatzNumofSequences(input_original)
        integer(kind=8), intent(in) :: input_original

        integer(kind=8) :: numofSeq, input

        numofSeq = 0
        input = input_original

        do while (input > 1)
            if (mod(input, 2) == 0) then
                input = input / 2
            elseif (mod(input, 2) == 1) then
                input = input * 3 + 1
            end if
            numofSeq = numofSeq + 1
        end do

        collatzNumofSequences = numofSeq
    end function collatzNumofSequences

    ! Subroutine to repeat collatzNumofSequences for a given range and print top ten
    subroutine collatzNumofSequencesPrintTopTen(lowerLimit, upperLimit)
        integer(kind=8), intent(in) :: lowerLimit, upperLimit

        type(Result) :: topTen(10)
        type(Result) :: emptyResult
        integer(kind=8) :: currMin, i, currentresult, cycles

        currMin = 0
        cycles = 0
        emptyResult = Result(0,0)

        do i = 1, 10
            topTen(i) = emptyResult
        end do
        

        do i = lowerLimit, upperLimit
            currentresult = collatzNumofSequences(i)
            call updateTopResults(topTen, i, currentresult, cycles)
        end do
         ! Print the top results
        call printResults(topTen)
    end subroutine collatzNumofSequencesPrintTopTen

end module CollatzModule

program CollatzNormal
    use CollatzModule

    integer(kind=8) :: lowerLimit, upperLimit, inputLimit, absoluteLimit, absoluteOdd
    integer :: num_args
    character(12) :: arg1string, arg2string

    ! Set default values
    lowerLimit = 0
    upperLimit = 0
    inputLimit = 2100000001
    absoluteLimit = int(huge(0), kind=8)
    absoluteOdd = ((absoluteLimit - 1) / 3) - 1


    num_args = COMMAND_ARGUMENT_COUNT()

    ! Check command line arguments
    if (num_args > 0) then
        call get_command_argument(1, arg1string)
        read (arg1string, *, IOSTAT=io_status) lowerLimit
    end if
    if (num_args == 2) then
        call get_command_argument(2, arg2string)
        read (arg2string, *, IOSTAT=io_status) upperLimit
    end if



    ! Check if bounds set properly
    if (lowerLimit > inputLimit .or. upperLimit > inputLimit) then
        print *, "Input is too large, please use a number 0 - 2.1 billion"
        stop 1
    end if

    if (lowerLimit > 0 .and. upperLimit == 0) then
        write(*, '(2I20)') lowerLimit, collatzNumofSequences(lowerLimit)
    elseif (lowerLimit > 0 .and. upperLimit > 0 .and. upperLimit > lowerLimit) then
        call collatzNumofSequencesPrintTopTen(lowerLimit, upperLimit)
    end if

end program CollatzNormal
