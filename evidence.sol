pragma solidity ^ 0.4.24;
 // 电子存证
contract Evidence {
 
    uint CODE_SUCCESS = 0;
    uint FILE_NOT_EXIST = 3002;
 
    uint FILE_ALREADY_EXIST = 3003;
    uint FILE_INVALID = 3004;
    uint FILE_VALID = 3005;
 
    struct FileEvidence {
        bytes fileHash; //什么地点、做了什么
        uint fileUploadTime; //什么时间
        address owner; //谁
        bool tag; //商品二维码Hash是否有效
    }
 
    // 文件hash对应的文件存证实体，该值会被持久化到区块链
    mapping(bytes => FileEvidence) fileEvidenceMap;
 
    function saveEvidence(bytes fileHash, uint fileUploadTime) public returns(uint code) {
 
        FileEvidence storage fileEvidence = fileEvidenceMap[fileHash];
        if (fileEvidence.fileHash.length != 0) {
            return FILE_ALREADY_EXIST;
        }
 
        fileEvidence.fileHash = fileHash;
        fileEvidence.fileUploadTime = fileUploadTime;
        fileEvidence.owner = msg.sender;
        fileEvidence.tag = false;
        return CODE_SUCCESS;
 
    }
 
    function getEvidence(bytes fileHash) public returns(uint code) {
        FileEvidence storage fileEvidence = fileEvidenceMap[fileHash];
        if (fileEvidence.fileHash.length == 0) {
            return FILE_NOT_EXIST;
        }
        if (fileEvidence.tag) {
            return FILE_INVALID;
        }
        fileEvidence.tag = true;
        return FILE_VALID;
    }
}