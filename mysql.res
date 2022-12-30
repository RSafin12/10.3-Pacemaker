resource mysql {    
    protocol C;
    
    disk {
        fencing resource-only;
    }    
    
    handlers {
        fence-peer
"/usr/lib/drbd/crm-fence-peer.sh";
        after-resync-target
"/usr/lib/drbd/crm-unfence-peer.sh";
    }
syncer {
        rate 110M;
        
    }    
    on brave
    {        
        device /dev/drbd1;
        disk /dev/vg0/mysql;
        address 172.16.16.16:7798;
        meta-disk internal;
    }    
    on strong
    {        
        device /dev/drbd1;
        disk /dev/vg0/mysql;
        address 172.16.16.15:7798;
        meta-disk internal; 
    }

}
