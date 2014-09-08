#ifndef Ad_IOS
#define Ad_IOS

namespace googleapi {

	void initAd(const char *ID, int x, int y, int size, bool testMode);
	void showAd();
	void hideAd();
	void refreshAd();
	void initInterstitial(const char *ID, bool testMode);
	void showInterstitial();

}

#endif
