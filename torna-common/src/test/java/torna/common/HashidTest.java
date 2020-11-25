package torna.common;

import org.hashids.Hashids;
import org.junit.Assert;
import org.junit.Test;
import torna.common.util.IdUtil;

/**
 * @author tanghc
 */
public class HashidTest {

    @Test
    public void testGen() {
        long val = 711111231231235L;
        String hash = IdUtil.encode(val);
        System.out.println(hash);

        long val2 = IdUtil.decode(hash);
        Assert.assertEquals(val, val2);
    }

}
