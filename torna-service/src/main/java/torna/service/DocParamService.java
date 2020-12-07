package torna.service;

import org.springframework.stereotype.Service;
import torna.common.bean.Booleans;
import torna.common.bean.User;
import torna.common.enums.ParamStyleEnum;
import torna.common.support.BaseService;
import torna.common.util.DataIdUtil;
import torna.dao.entity.DocInfo;
import torna.dao.entity.DocParam;
import torna.dao.mapper.DocParamMapper;
import torna.service.dto.DocParamDTO;

import java.util.List;

/**
 * @author tanghc
 */
@Service
public class DocParamService extends BaseService<DocParam, DocParamMapper> {

    public DocParam getByDataId(String dataId) {
        return get("data_id", dataId);
    }

    public void saveParams(DocInfo docInfo, List<DocParamDTO> docParamDTOS, ParamStyleEnum paramStyleEnum, User user) {
        if (docParamDTOS == null) {
            return;
        }
        for (DocParamDTO docParamDTO : docParamDTOS) {
            this.doSave(docParamDTO, 0L, docInfo, paramStyleEnum, user);
        }
    }

    private void doSave(DocParamDTO docParamDTO, long parentId, DocInfo docInfo, ParamStyleEnum paramStyleEnum, User user) {
        DocParam docParam = new DocParam();
        String dataId = DataIdUtil.getDocParamDataId(docInfo.getId(), parentId, paramStyleEnum.getStyle(), docParamDTO.getName());
        docParam.setDataId(dataId);
        docParam.setName(docParamDTO.getName());
        docParam.setType(docParamDTO.getType());
        docParam.setRequired(docParamDTO.getRequired());
        docParam.setMaxLength(docParamDTO.getMaxLength());
        docParam.setExample(docParamDTO.getExample());
        docParam.setDescription(docParamDTO.getDescription());
        docParam.setEnumId(docParamDTO.getEnumId());
        docParam.setDocId(docInfo.getId());
        docParam.setParentId(parentId);
        docParam.setStyle(paramStyleEnum.getStyle());
        docParam.setModifyMode(user.getOperationModel());
        docParam.setModifierId(user.getUserId());
        docParam.setModifierName(user.getNickname());
        docParam.setIsDeleted(docParamDTO.getIsDeleted());
        DocParam savedParam = this.saveParam(docParam, user);
        List<DocParamDTO> children = docParamDTO.getChildren();
        if (children != null) {
            Long id = savedParam.getId();
            for (DocParamDTO child : children) {
                this.doSave(child, id, docInfo, paramStyleEnum, user);
            }
        }
    }

    public DocParam saveParam(DocParam docParam, User user) {
        String dataId = docParam.getDataId();
        DocParam docParamExist = getByDataId(dataId);
        if (docParamExist != null) {
            if (docParam.getIsDeleted() != null && docParam.getIsDeleted() == Booleans.TRUE) {
                this.delete(docParamExist);
                return docParamExist;
            }
            docParamExist.setName(docParam.getName());
            docParamExist.setType(docParam.getType());
            docParamExist.setRequired(docParam.getRequired());
            docParamExist.setMaxLength(docParam.getMaxLength());
            docParamExist.setExample(docParam.getExample());
            docParamExist.setDescription(docParam.getDescription());
            docParamExist.setEnumId(docParam.getEnumId());
            docParamExist.setStyle(docParam.getStyle());
            docParamExist.setModifyMode(docParam.getModifyMode());
            docParamExist.setModifierName(docParam.getModifierName());
            docParamExist.setModifierId(docParam.getModifierId());
            docParamExist.setIsDeleted(Booleans.FALSE);
            updateIgnoreNull(docParamExist);
            return docParamExist;
        } else {
            docParam.setCreatorId(user.getUserId());
            docParam.setCreateMode(user.getOperationModel());
            docParam.setCreatorName(user.getNickname());
            saveIgnoreNull(docParam);
            return docParam;
        }
    }

}
