function [cropped_img,img_footer] = footerremove(img)
    footer_found = 0;
    WHITE = 255;

    for i = 1:size(img,1)
        if sum(img(i,:)) == size(img,2)*WHITE && ...
                footer_found == 0
            cropped_img = img(1:i-1,:);
            img_footer = img(i-1:end,:);
            footer_found = 1;
        end
    end

    if footer_found == 0
        cropped_img = img;
    end
end