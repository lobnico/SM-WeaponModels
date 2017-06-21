
void InitDataMapOffset(int &offset, int entity, const char[] propName)
{
	if ((offset = FindDataMapInfo(entity, propName)) == -1)
	{
		SetFailState("Fatal Error: Failed to find offset: \"%s\"!", propName);
	}
}