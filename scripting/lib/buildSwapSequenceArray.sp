
// This algorithm gives me an headache, even though I made it myself. But it's as fast as it can be I hope
int BuildSwapSequenceArray(int swapSequences[MAX_SEQEUENCES], int sequenceCount, int weapon, int index = 0)
{
	int value = swapSequences[index], swapIndex = -1;

	if (!value)
	{
		// Continue to next if sequence wasn't an activity
		if ((value = swapSequences[index] = Animating_GetSequenceActivity(weapon, index)) == -1)
		{
			if (++index < sequenceCount)
			{
				BuildSwapSequenceArray(swapSequences, sequenceCount, weapon, index);

				return -1;
			}

			return 0;
		}
	}
	else if (value == -1)
	{
		if (++index < sequenceCount)
		{
			BuildSwapSequenceArray(swapSequences, sequenceCount, weapon, index);

			return -1;
		}
		
		return 0;
	}
	else if (value & SWAP_SEQ_PAIRED)
	{
		// Get the index
		swapIndex = (value & ~SWAP_SEQ_PAIRED) >> 16;

		// Get activity value
		value &= 0x0000FFFF;
	}
	else
	{
		return 0;
	}

	for (int i = index + 1; i < sequenceCount; i++)
	{
		int nextValue = BuildSwapSequenceArray(swapSequences, sequenceCount, weapon, i);

		if (value == nextValue)
		{
			swapIndex = i;

			// Let the index be be stored after the 16th bit, and add a bit-flag to indicate this being done
			swapSequences[i] = nextValue | (index << 16) | SWAP_SEQ_PAIRED;

			break;
		}
	}

	swapSequences[index] = swapIndex;

	return value;
}
