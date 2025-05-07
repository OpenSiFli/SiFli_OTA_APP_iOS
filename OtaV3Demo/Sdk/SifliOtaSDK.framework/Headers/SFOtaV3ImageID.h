//
//  SFOtaV3ImageID.h
//  SifliOtaSDK
//
//  Created by Sean on 2024/7/27.
//

#ifndef SFOtaV3ImageID_h
#define SFOtaV3ImageID_h

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SFOtaV3ImageID) {
    SFOtaV3ImageIDHcpu = 0,
    SFOtaV3ImageIDLcpu = 1,
    SFOtaV3ImageIDLcpuPatch = 2,
    SFOtaV3ImageIDNorResOrNandPic = 3,
    SFOtaV3ImageIDNorFontOrNandFont = 4,
    SFOtaV3ImageIDNorRootOrNandLang = 5,
    SFOtaV3ImageIDNorOtaManagerOrNandRing = 6,
    SFOtaV3ImageIDNorTinyFontOrNandRoot = 7,
    SFOtaV3ImageIDNandMusic = 8,
    SFOtaV3ImageIDNandDyn = 9,
    SFOtaV3ImageIDNandNym = 10
};



NS_ASSUME_NONNULL_END
#endif /* SFOtaV3ImageID_h */
