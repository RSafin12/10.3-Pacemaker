resource www {    
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
        device /dev/drbd2;
        disk /dev/vg0/www;
        address 172.16.16.16:7794;
        meta-disk internal;
    }    
    on strong
    {        
        device /dev/drbd2;
        disk /dev/vg0/www;
        address 172.16.16.15:7794;
        meta-disk internal; 
    }

}

