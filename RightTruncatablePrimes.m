function [] = RightTruncatablePrimes()
% RightTruncatablePrimes() prints all right-truncatable primes (83 of them).
% Refer to "Truncatable prime" in https://en.wikipedia.org/wiki/Truncatable_prime

% Constants
RIGHTTRUNCATABLESIZE = 90;      % We know there are 83 right truncatable primes.
                                % This is somewhat cheating, but warning codes
                                % are in place to signal if
                                % RIGHTTRUNCATABLESIZE is not large enough.
UPPERBOUND_RTRUNCATABLEPRIME = (intmax - 9)/10;
                                % When we reach this upper bound, we risk
                                % integer overflow during calculation.

% Initializing listRightTruncatablePrimes
listRightTruncatablePrimes = zeros(RIGHTTRUNCATABLESIZE, 1);
listRightTruncatablePrimes(1:4) = [2, 3, 5, 7];
rightTruncatablePrimesLen = 4;
currRightTruncatablePrimeIndex = 1;

% Starting the iteration to derive more right truncatable primes.
startTime = tic;
while currRightTruncatablePrimeIndex <= rightTruncatablePrimesLen
    % We will start with listRightTruncatablePrimes(currRightTruncatablePrimeIndex)
    % and see if we can get a new prime by appending 1, 3, 7 or 9 to its
    % right.  It is obvious we don't need to try 5 or another even digit.
    % If we get another prime, we append it to the end of the list.
    % Naturally the list is sorted in ascending order.
    currRightTruncatablePrime = listRightTruncatablePrimes(currRightTruncatablePrimeIndex);
    if currRightTruncatablePrime >= UPPERBOUND_RTRUNCATABLEPRIME
        fprintf(2, 'WARNING -- Handling large integers and overflow can happen!\n');
        break;
    end
    
    listNewCandidates = zeros(4, 1);
    % Trying appending 1 at the right.
    newCandidate = currRightTruncatablePrime*10 + 1;
    if isPrime(newCandidate)
        listNewCandidates(1) = newCandidate;
    end
    
    % Trying appending 3 at the right.
    newCandidate = currRightTruncatablePrime*10 + 3;
    if isPrime(newCandidate)
        listNewCandidates(2) = newCandidate;
    end
    
    % Trying appending 7 at the right.
    newCandidate = currRightTruncatablePrime*10 + 7;
    if isPrime(newCandidate)
        listNewCandidates(3) = newCandidate;
    end
    
    % Trying appending 9 at the right.
    newCandidate = currRightTruncatablePrime*10 + 9;
    if isPrime(newCandidate)
        listNewCandidates(4) = newCandidate;
    end
    
    % See if we want to append listNewCandidates to listRightTruncatablePrimes
    % after removing zero entries in listNewCandidates.
    listNewCandidates(listNewCandidates == 0) = [];
    if ~isempty(listNewCandidates)
        if (rightTruncatablePrimesLen + length(listNewCandidates)) > RIGHTTRUNCATABLESIZE
            % We exceeded the allocated buffer for right-truncatable primes.
            fprintf(2, 'WARNING -- The preallocated buffer for right-truncatable primes is not large enough!\n');
        end
        
        listRightTruncatablePrimes((rightTruncatablePrimesLen + 1): ...
                                   (rightTruncatablePrimesLen + length(listNewCandidates))) = ...
            listNewCandidates;
        rightTruncatablePrimesLen = rightTruncatablePrimesLen + length(listNewCandidates);
    end
    
    % Getting ready to check out the next candidates.
    currRightTruncatablePrimeIndex = currRightTruncatablePrimeIndex + 1;
end
elapsedTime = toc(startTime);

% We are done.  Print out the right truncatable primes.  We only want to
% print the beginning and the end of the truncatable primes.
for i = 1:rightTruncatablePrimesLen
    if (i < 10) || (i >= 80)
        switch mod(i, 10)
            case 1
                ordinalStr = 'st';
            case 2
                ordinalStr = 'nd';
            case 3
                ordinalStr = 'rd';
            otherwise
                ordinalStr = 'th';
        end
        disp(['The ' num2str(i) ordinalStr ' right-truncatable prime is ' ...
              num2str(listRightTruncatablePrimes(i))]);
    elseif i == 10
        disp('......');
    end
end
disp(['Elapsed Time: ' num2str(elapsedTime) ' seconds.']);


% Function isPrime() tests if the given input x is a prime number by using
% trivial division.  It is very slow but gives a definite answer.  Refer to
% "Primality test" in https://en.wikipedia.org/wiki/Primality_test for more
% details.
function [y] = isPrime(x)

% In isPrime(), we first test if x is an integer and if x is even.  Then we
% check if odd numbers of the form 6n+1 and 6n+5 can divide x.
if (x <= 1) || (x ~= fix(x))
    y = false;
    return;
end

% Now x must be a positive integer.  Handling the case for 2.
if (x == 2) || (x == 3)
    y = true;
    return;
elseif  mod(x, 2) == 0
    y = false;
    return;
elseif  mod(x, 3) == 0
    y = false;
    return;
end

y = true;
n = 1;
testingDivisor = 6*n + 1;
while testingDivisor*testingDivisor <= x
    if mod(x, testingDivisor) == 0
        y = false;
        return;
    end
    testingDivisor = testingDivisor + 6;    % n++
end

n = 0;
testingDivisor = 6*n + 5;
while testingDivisor*testingDivisor <= x
    if mod(x, testingDivisor) == 0
        y = false;
        return;
    end
    testingDivisor = testingDivisor + 6;    % n++
end
